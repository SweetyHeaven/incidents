
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