
$(document).ready(function(){ 
	$(".user-select").chosen();

  $("#incident_tag_ids").tokenInput("/tags/search",{
                preventDuplicates: true,
                theme: "facebook"
            });

//add listner on search feild
var searchField = $("#token-input-incident_tag_ids")[0];
searchField.addEventListener("keydown", keyPressed, true);

function keyPressed (e) {
    var keyCode = e.keyCode;
    console.log(keyCode)
    if (keyCode == 13) //Enter is pressed
    {
      if(searchField.value.length > 0) {  //no previous tag matched
        console.log("not found");
        
        //prevent form from submition
        e.stopPropagation();
        e.preventDefault();

        //add a new tag to DB
        var newTag = searchField.value;
        $.ajax({url:"/tags",
                type: "POST",          
                data: {tag: {name: newTag}},
                success:function(tag){
                          //update select list
                          $("#incident_tag_ids").tokenInput("add", {id: tag.id, name: tag.name});
                          console.log(tag);
              }});
      }
    }
    
  }      


  /*$(".chzn-select").chosen();
  $(".chzn-select").chosen().change(function(){
    console.log("found");
  });
*/
});
  

//Add a listener on radio buttons
$(document).ready(function(){ 
  var positiveButton = $("#incident_incident_type_1")[0];
  var negativeButton = $("#incident_incident_type_-1")[0];
  var scoreField = $("#incident_score")[0];

  function radioButtonClicked(){
    if (this.value == -1 && scoreField.value > 0) 
    {
      scoreField.value = scoreField.value * -1;  
    }

    if (this.value == 1 && scoreField.value < 0) 
    {
      scoreField.value = scoreField.value * -1;  
    }
    
  }

  //add events
  positiveButton.addEventListener("click", radioButtonClicked,true); 
  negativeButton.addEventListener("click", radioButtonClicked,true);

});

/*
//Adds a listner for the search textField in order to add
//new tags using Ajax calls
$(document).ready(function(){ 
  var inputs = $("input");
  var searchField = inputs[inputs.length-3];
  searchField.addEventListener("keyup", keyPressed, true);

  function keyPressed (e) {
    var keyCode = e.keyCode;
    if (keyCode == 13) //Enter is pressed
    {
      if(searchField.value.length > 0) {  //no previous tag matched
        console.log("not found");
        
        //add a new tag to DB
        var newTag = searchField.value;
        $.ajax({url:"/tags",
                type: "POST",          
                data: {tag: {name: newTag}},
                success:function(tag){
                          //update select list
                          $(".chzn-select").append('<option selected = "selected" value="'+tag.id+'">'+tag.name+'</option>');
                          $(".chzn-select").trigger("liszt:updated");
                          console.log(tag);
                          console.log(tag.id);
              }});
      };
    }else{
      if (keyCode == 40) {return;}; //skip down key

      var queryString = searchField.value;
      if(queryString.length >0){
        $.ajax({url:"/tags/search",
          type: "GET",          
          data: {query: queryString},
          beforeSend: function(){},
          success:function(tags){
                    //update select list
                    resetSelect();
                    //$('ul.chzn-results').empty();
                    var tagsList = JSON.parse(tags);
                    for (var i = 0; i < tagsList.length; i++) {
                      tag = tagsList[i]
                      console.log(tag)
                      $(".chzn-select").append('<option value="'+tag[0]+'">'+tag[1]+'</option>');
                      //$('ul.chzn-results').append('<li class="active-result">' + tag[1] + '</li>');
                    };
                    $(".chzn-select").trigger('liszt:updated');
                    //$(".chzn-select")[0].firstChild.focus();
                    searchField.value = queryString; //keep search field state

                    console.log(tags);
        }});
      }
    }
  }

  //refreshes the select element and keep the 
  //previosly selected options
  function resetSelect(){
    var newOPtions = "";
    var chooser = $(".chzn-select")[0];
    var options = $(".chzn-select").find('option');
    for (var i = options.length - 1; i >= 0; i--) {
      option = options[i];
      chooser.removeChild(option);

      var selected = option.selected
      if (selected) {
        var id = option.value;
        var name = $(option).html();
        newOPtions += '<option selected = "selected" value="'+id+'">'+name+'</option>';
      };
      
      console.log(selected+"  "+id+"  "+name);
    };
    console.log(newOPtions);
    $(".chzn-select").append(newOPtions);
    $(".chzn-select").trigger("liszt:updated");
  }

});
*/