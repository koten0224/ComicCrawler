import "./searcher.js"
import axios from "axios"
import $ from "jquery"

$(document).ready(function() {
  let token = $('meta[name="csrf-token"]').attr("content")
  let email = $("#user-email").val()
  $(".get-comic").on('click', function(eve){
    eve.preventDefault()
    let name = $(this).attr("comic-name")
    let id = $(this).attr("comic-id")
    let start = $("#episode-start") && $("#episode-start").val()
    let ending = $("#episode-ending") && $("#episode-ending").val()
    if(confirm(`是否自動補完 ${name} 最新進度？`)){
      axios.post("/send", {
        authenticity_token: token,
        id: id,
        email: email,
        start: start,
        ending: ending,
      })
      .then(function(resp){
        if(resp.status===200){
          alert("最新進度稍候將寄出至您信箱，敬請稍等哦！")
        }
      })
    }
  })
})