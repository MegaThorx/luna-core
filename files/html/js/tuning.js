function addTuning(text, id){
  $("#dialog-tuning").append('<a href="#" class="btn waves-effect waves-light grey button-tuning" onclick="onClickTuning(\'' + id + '\')">' + text + '</a>');
}

function addCloseTuning(text, id){
  $("#dialog-tuning").append('<a href="#" class="btn waves-effect waves-light black button-tuning" onclick="onClickTuning(\'' + id + '\')">' + text + '</a>');
}

function clearTunings(){
  $("#dialog-tuning").children().each(function(_, item){
    item.remove();
  });
}

function onClickTuning(id){
  $.ajax({url: "http://mta/local/ajax.htm?tuning", method: "POST", data: { id: id }});
}

function hideTuning(){
  $("#dialog-tuning").css("visibility", "hidden");
}

function showTuning(){
  $("#dialog-tuning").css("visibility", "visible");
}
