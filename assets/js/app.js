// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import socket from "./socket";

var channel = socket.channel("general:lobby", {}); // connect to chat "room"

var typeNames = {
  inn: "ИНН",
  kpp: "КПП",
  ogrn: "ОГРН"
};

var ul = document.getElementById("list");
channel.on("shout", function(payload) {
  // listen to the 'shout' event
  var li = document.createElement("li"); // creaet new list item DOM element
  li.innerHTML =
    "<p>[" +
    new Date(payload.datetime).toLocaleString() +
    "] " +
    typeNames[payload.type] +
    " " +
    payload.data +
    " " +
    (payload.result ? "корректен" : "некорректен") +
    "</p>"; // set li contents
  ul.appendChild(li); // append to list
});

channel.join();

var innInput = document.getElementById("inn-input");
var innButton = document.getElementById("inn-button");
innButton.addEventListener("click", function(event) {
  channel.push("shout", {
    data: innInput.value,
    type: "inn"
  });
  innInput.value = "";
});

var kppInput = document.getElementById("kpp-input");
var kppButton = document.getElementById("kpp-button");
kppButton.addEventListener("click", function(event) {
  channel.push("shout", {
    data: kppInput.value,
    type: "kpp"
  });
  kppInput.value = "";
});

var ogrnInput = document.getElementById("ogrn-input");
var ogrnButton = document.getElementById("ogrn-button");
ogrnButton.addEventListener("click", function(event) {
  channel.push("shout", {
    data: ogrnInput.value,
    type: "ogrn"
  });
  ogrnInput.value = "";
});
