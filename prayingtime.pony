use "collections"
use "net/http"
use "json"

actor Main
  new create(env: Env) =>
    let city = "Tashkent"
    let url = "http://api.aladhan.com/v1/timingsByCity?city=" + city + "&country=Uzbekistan&method=2"
    HTTPClient(env.root as AmbientAuth).get(url, PrayerHandler)

class PrayerHandler is HTTPHandler
  fun ref apply(response: HTTPResponse ref) =>
    try
      let json = JsonDoc.parse(String.from_array(response.body))?.data as JsonObject
      let data = json.data("data") as JsonObject
      let timings = data.data("timings") as JsonObject
      let fajr = timings.data("Fajr") as JsonString
      let maghrib = timings.data("Maghrib") as JsonString
      @printf[I32]("Bomdod: %s\nShom: %s\n".cstring(), fajr.string().cstring(), maghrib.string().cstring())
    else
      @printf[I32]("Xatolik\n".cstring())
    end
