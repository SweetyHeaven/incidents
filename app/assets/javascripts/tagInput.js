
$(document).ready(function(){ 
	$(".chzn-select").chosen();
  $(".chzn-select").chosen().change(function(){
    console.log("found");
  });

});
  

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
    };
  }

});
