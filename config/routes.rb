Rails.application.routes.draw do
  root "main#index"
  resources :comics
  get  "/search",      to: "comics#search_form", as: "search"
  get  "/search_json", to: "comics#search",      as: "search_json"
  post "/send",        to: "comics#send_comic",  as: "send"
  get  "/comic_list",  to: "comics#comic_list",  as: "comic_list"
end
