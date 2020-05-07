import "./searcher.js"

$(document).ready(function() {
  let token = $('meta[name="csrf-token"]').attr("content")
  let email = $("#user-email").val()
  $(".get-comic").on('click', function(eve){
    eve.preventDefault()
    let name = $(this).attr("comic-name")
    let id = $(this).attr("comic-id")
    let start = $("#episode-start") && $("#episode-start").val()
    let stop = $("#episode-stop") && $("#episode-stop").val()
    if(confirm(`是否補完 ${name} 進度？`)){
      axios.post("/send", {
        authenticity_token: token,
        id: id,
        email: email,
        start: start,
        stop: stop,
      })
      .then(function(resp){
        if(resp.status===200){
          alert("稍候漫畫將寄出至您信箱，敬請稍等哦！")
        }
      })
    }
  })
})