// import { $ } from "jquery"
import axios from "axios"
import $ from "jquery"
$(document).ready(function() {
  let token = $('meta[name="csrf-token"]').attr("content")
  $("#comic_search").on("click", function(eve) {
    eve.preventDefault()
    $("#search_result tr").remove()
    $(".loading").show()
    let input = $("#comic_name")
    let comic_name = input.val()
    input.val("")
    let url=`/search_json?comic_name=${comic_name}`
    axios.get(url)
         .then(function(resp){
          for(let data of resp.data){
            $("#search_result").append(formatHTML(data))
            }
            $(".loading").hide()
         })
  })
  $("#search_result").on("click", "button", function(eve) {
    eve.preventDefault()
    let comic_name = $(this).attr("data-name")
    let comic_link = $(this).attr("data-link")
    if(confirm(`確定新增這篇漫畫：${comic_name} ?`)){
      axios.post("/comics", {
        authenticity_token: token,
        comic_name: comic_name,
        comic_link: comic_link,
      })
      .then(function(resp){
        console.log(resp)
        if(resp.status === 200){
          alert(`已新增 ${comic_name} ！`)
        }
      })
      .catch(function(err){
        console.log(err)
      })
    }

  })
})

function formatHTML(data){
  return `
  <tr>
    <td>
      <a href="${data.link}">${data.title}</a>
    </td>
    <td>
      <button data-link="${data.link}" data-name="${data.title}">新增</button>
    </td>
  </tr>
  `
}