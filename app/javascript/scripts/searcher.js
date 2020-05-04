let page = 1
let comic_name = ""
$(document).ready(function() {
  let token = $('meta[name="csrf-token"]').attr("content")
  $("#comic_search").on("click", function(eve) {
    eve.preventDefault()
    page = 1
    $("#search_result tr").remove()
    let input = $("#comic_name")
    comic_name = input.val()
    input.val("")
    axiosGet()
  })
  $("#search_result").on("click", "#next-page", function(eve){
    eve.preventDefault()
    axiosGet()
  })
  $("#search_result").on("click", ".new", function(eve) {
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

function axiosGet(){
  $(".loading").show()
  $("tr.last").remove()
  let url=`/search_json?comic_name=${comic_name}&page=${page}`
  axios.get(url)
        .then(function(resp){
        for(let data of resp.data){
          $("#search_result").append(formatHTML(data))
          }
          $(".loading").hide()
          page += 1
          console.log(resp.data.length)
          if(resp.data.length === 30){
            $("#search_result").append(nextButton())
          }
        })
}

function formatHTML(data){
  return `
  <tr>
    <td>
      <a href="${data.link}">${data.title}</a>
    </td>
    <td>
      <button class="new" data-link="${data.link}" data-name="${data.title}">新增</button>
    </td>
  </tr>
  `
}

function nextButton(){
  return `
  <tr class="last">
    <td>
      <button id="next-page">下一頁</button>
    </td>
  </tr>
  `
}