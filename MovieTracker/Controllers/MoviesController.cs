using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using MovieTracker.Models;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Reflection;
using System.IO;
using Newtonsoft.Json.Linq;
using PagedList.Mvc;
using PagedList;

namespace MovieTracker.Controllers
{
    public class MoviesController : Controller
    {
        private DWSMovieTrackerEntities db = new DWSMovieTrackerEntities();

        //GET: Get all movies, or get searched movies
        //displays results to ~/Views/Movies/Index
        #region Index
        public ActionResult Index(string search, string sortOrder, string CurrentSort, int? page)
        {
            //Set details for page index
            int pageSize = Properties.Settings.Default.PageSize;
            int pageIndex = Properties.Settings.Default.PageIndex;
            pageIndex = page.HasValue ? Convert.ToInt32(page) : 1;

            //Index view receives search field from layout page and executes a search
            //if the search is populated
            if (!string.IsNullOrEmpty(search))
            {
                //Declare a new business logic class to execute the search
                var business = new MovieBusinessLogic();

                //Send search value to the Get Movies method and returns all matching movies
                var model = business.GetMovies(search);

                //Since we are going to have a lot of movies, we need to use paging
                //This implements the Nuget class PagedList.Mvc Nuget class
                return View(model.OrderBy(i => i.Title).ToPagedList(pageIndex, pageSize));
            }

            //We're not searching anything, so return default list of movies
            //Remember to use Paging
          
            return View(db.Movie.OrderBy(i => i.Title).ToPagedList(pageIndex, pageSize));
        }
        #endregion

        //GET: Get a movie based on movie id and display results
        #region Details
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Movie movie = db.Movie.Find(id);
            if (movie == null)
            {
                return HttpNotFound();
            }
            return View(movie);
        }
        #endregion

        // POST: Inserts a new movie into the database
        // Calls a restful webservice to autopopulate movie details based on a title entered.
        #region Create
        public ActionResult Create()
        {
            return View();
        }

       //POST: Movies/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MovieId,Title,MovieYear,MovieType,Location,Director,Plot,Poster,ActorString,GenreString")] Movie movie, string create, string autopopulate)
        {
            //Because the form has two buttons, the method receives two string variables to determine which button was pressed.
            if(!string.IsNullOrEmpty(create))
            { 
                if (ModelState.IsValid)
                {
                    try
                    {
                        //Sends all form details to the upsert stored procedure in SQL
                        db.Upsert_Movie(movie.MovieId, movie.Title,
                        movie.MovieYear, movie.MovieType,
                        movie.Location, movie.Director,
                        movie.Plot, movie.Poster,
                        movie.ActorString, movie.GenreString);

                        db.SaveChanges();
                    }
                    catch (Exception)
                    {
                        throw;
                    }
                
                    return RedirectToAction("Index");
                }
            }

            if (!string.IsNullOrEmpty(autopopulate))
            {
                //Calls the Get Movies method to get movie details from rest service
                Movie _populatedMovie = new Movie();
                _populatedMovie = AutoPopulateMovies(movie);
                if(_populatedMovie.Title != null)
                {
                    ModelState.Clear();
                    return View(_populatedMovie); 

                }
                else
                {
                    ModelState.AddModelError("Title", "Title not found on Open Movie Database.");
                }
                
            }

            return View(movie);
        }
        #endregion

        //This method is called by the Create Action
        //Method calls the restful webservice hosted by the
        //open movie database. 
        //Receives JSON with movie details, deserializes and populates the Create form.
        #region GetMovies
        public Movie AutoPopulateMovies(Movie movie)
        {
            MovieDetails MovieDetails = new MovieDetails();

            using (var client = new HttpClient())
            {
                //Populates the OMDB Url, along with the movie title added in the form, and ads the API key needed to call web service.
                //EscapeDataString method added to allow users to search names with special characters. example &
                var url = Properties.Settings.Default.OMDBLink + Uri.EscapeDataString(movie.Title) + Properties.Settings.Default.APIKey;
                var webrequest = (HttpWebRequest)System.Net.WebRequest.Create(url);

                using (var response = webrequest.GetResponse())
                using (var reader = new StreamReader(response.GetResponseStream()))
                {
                    var result = reader.ReadToEnd();
                    //Deserializing the response recieved from web api and storing into the Movie list  
                    JObject _jsonResponseObj = JObject.Parse(result);
                    try
                    {
                        MovieDetails = _jsonResponseObj.ToObject<MovieDetails>();
                    }
                    catch (Exception )
                    {
                        ModelState.AddModelError("Title", "Error retrieving movie from database. Make sure you enter a valid movie.");
                    }
                    
                }

                //Bind populated data to movie and return
                //Inplicit conversion was done in the Movie model
                movie = MovieDetails;
                return movie;

            }
        }
        #endregion

        // GET: Edits an existing movie
        // Updates SQL server with new movie details
        #region Edit
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Movie movie = db.Movie.Find(id);
            if (movie == null)
            {
                return HttpNotFound();
            }
            return View(movie);
        }
        

        // POST: Movies/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MovieId,Title,MovieYear,MovieType,Location,Director,Plot,Poster,ActorString,GenreString")] Movie movie, string save, string autopopulate)
        {
            if (!string.IsNullOrEmpty(save))
            {
                if (ModelState.IsValid)
                {
                    try
                    {
                        //We use the upsert stored precedure here, because we want to make sure
                        //we change all the database associations and not only the Movie table.
                        db.Upsert_Movie(movie.MovieId, movie.Title,
                        movie.MovieYear, movie.MovieType,
                        movie.Location, movie.Director,
                        movie.Plot, movie.Poster,
                        movie.ActorString, movie.GenreString);
                        
                        db.SaveChanges();
                        
                    }
                    catch (Exception)
                    {
                        throw;
                    }
                }
            }

            if (!string.IsNullOrEmpty(autopopulate))
            {
                //Calls the Get Movies method to get movie details from rest service
                Movie _populatedMovie = new Movie();
                _populatedMovie = AutoPopulateMovies(movie);
                if (_populatedMovie.Title != null)
                {
                    ModelState.Clear();
                    return View(_populatedMovie);

                }
                else
                {
                    ModelState.AddModelError("Title", "Title not found on Open Movie Database.");
                }

            }
            //Update complete, return to view movie details.
            return View("Details", movie);

        }
        #endregion

        // GET: Deletes an existing movie from the database
        #region Delete
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Movie movie = db.Movie.Find(id);
            if (movie == null)
            {
                return HttpNotFound();
            }
            return View(movie);
        }

        // POST: Movies/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            //We call the DeleteMovie stored procedure, because
            //we want to make sure all the associations are deleted.
            db.DeleteMovie(id);
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        #endregion

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }

       
}
