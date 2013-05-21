// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function testJS() {
  $("h1").text("WOW! jQuery is working!");
  $("#smallText").text("I can even change the small text with id!");

 // create table
  var $table = $('<table>');

  // caption
  $table.append('<caption>MyTable</caption>')

  // thead
  .append('<thead>').children('thead')
  .append('<tr />').children('tr').append('<th>A</th><th>B</th><th>C</th><th>D</th>');

  //tbody
  var $tbody = $table.append('<tbody />').children('tbody');

  // add row
  $tbody.append('<tr />').children('tr:last')
  .append("<td>value1</td>")
  .append("<td>value2</td>")
  .append("<td>value3</td>")
  .append("<td>value4</td>");

  // add table to dom
  $table.appendTo('#dynamicTable');

  $("#dynamicTable").addClass("table");
}
