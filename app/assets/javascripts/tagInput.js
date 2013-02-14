$(document).ready(function(){ 
	$(".chzn-select").chosen({
    	create_option: function(term){
      		var chosen = this;
      		$.post('add_term.php', {term: term}, function(data){
        	chosen.append_option({
        		value: 'value-' + data.term,
        		text: data.term
        	});
      	});
    	}
  });
});

$(document).ready(function(){ 
  $(".chzn-select").chosen().change(function(){
    
  });
});