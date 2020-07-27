//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require cocoon
//= require action_cable
//= require skim
//= require_tree .

var App = App || {};
App.cable = ActionCable.createConsumer();
