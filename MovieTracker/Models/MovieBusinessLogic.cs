using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MovieTracker.Models
{
    public class MovieBusinessLogic
    {
        private DWSMovieTrackerEntities db;
        public MovieBusinessLogic()
        {
            db = new DWSMovieTrackerEntities();
        }

        public IEnumerable<Movie> GetMovies(string searchString)
        {
            //Instantiate both reader and movie list
            var ReaderList = new List<Movie_Reader_Result>();
            var MovieList = new List<Movie>(); 
            
            //Retrieve all matching movies from the Movie_Reader stored procedure
            ReaderList = db.Movie_Reader(searchString).ToList();

            //We need to loop through the reader list and bind them to the movie list
            foreach (Movie_Reader_Result a in ReaderList)
            {
                MovieList.Add(new Movie() {
                    MovieId = a.MovieID, Title = a.Title, MovieYear = a.MovieYear, MovieType = a.MovieType,
                    Director = a.Director, Plot = a.Plot, Poster = a.Poster, ActorString = a.Actors, GenreString = a.Genres });
            }

            //Return new movie list
            return MovieList;
        }

    }
}