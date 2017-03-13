// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require bootstrap-select
//= require toastr
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require turbolinks
//= require Chart.bundle
//= require chartkick
// = require_tree .


$( document ).on('turbolinks:load', function() {

  $('.month_datepicker').datepicker({
    format: "mm/yyyy",
    altFormat: "yyyy-MM-dd",
    startView: "year",
    minViewMode: "months",
    //defaultDate: new Date()
  });

  $('.datatable').DataTable({
    "paging":   false,
    "info":     false,
    "searching":   false
  });

  $('.no-sort').removeClass('sorting');
  if ($('[aria-label^="ranking"]').length > 0) {
    $('[aria-label^="ranking"]')[0].click();
  };

  $(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();
  });

  $(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();
  });

  $('.selectpicker').selectpicker();
});