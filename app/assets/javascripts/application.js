//= require jquery3
//= require popper
//= require bootstrap
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require cocoon
//= require action_cable
//= require_tree .

var App = App || {};
App.cable = ActionCable.createConsumer();
