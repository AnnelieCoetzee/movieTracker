using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MovieTracker.Models;

namespace MovieTracker.Controllers
{
    public class HomeController : Controller
    {
        //private DWSMovieTrackerEntities _db = new DWSMovieTrackerEntities();

        // GET: Home
        public ActionResult Index()
        {
            return View();
        }
    }
}
