using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MovieTracker.Models
{
    public class MovieDetails
    {
        [JsonProperty(PropertyName = "Title")]
        public string Title { get; set; }

        [JsonProperty(PropertyName = "Year")]
        public int Year { get; set; }

        [JsonProperty(PropertyName = "Genre")]
        public string Genre { get; set; }

        [JsonProperty(PropertyName = "Director")]
        public string Director { get; set; }

        [JsonProperty(PropertyName = "Actors")]
        public string Actors { get; set; }

        [JsonProperty(PropertyName = "Plot")]
        public string Plot { get; set; }

        [JsonProperty(PropertyName = "Poster")]
        public string Poster { get; set; }



        //Rest service allows for other parameters, to be added in a later stage
        
        //public string Type { get; set; }
        //public string Language { get; set; }
        //public string Country { get; set; }
        //public string Awards { get; set; }
        //public string Writer { get; set; }
        //public string Rated { get; set; }
        //public string Released { get; set; }
        //public string Runtime { get; set; }
        //public string DVD { get; set; }
        //public string BoxOffice { get; set; }
        //public string Production { get; set; }
        //public string Website { get; set; }
        //public string Response { get; set; }
        //public Ratings Ratings { get; set; }
        //public string Metascore { get; set; }
        //public string imdbRating { get; set; }
        //public string imdbVotes { get; set; }
        //public string imdbID { get; set; }
    }

}