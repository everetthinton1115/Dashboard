$(function () {
  // ------Clipboard Start-------
  var clipboard = new Clipboard('.clipboard-btn');
  // ------Clipboard End-------

  $(document).on('click','#customRadioInline1', function() {
    $("#charity_attributes").remove();
    $("#501c_doc_2").remove();
  });

  $(document).on('click','#customRadioInline4', function() {
    $("#charity_attributes").remove();
    $("#501c_doc_2").remove();
  });

  $(document).on('click','#customRadioInline2', function() {
    $.ajax({
      method: 'GET',
      url: '/area_of_interest',
      data: { interest_type: $(this).val() },
      success: function(response){
        
        var charity_html =  '<div id="charity_attributes"><div class="row"><div class="col-md-6"><div class="form-group"><label class="control-label" for="user_alliance_attributes_area_of_interest_id">Areas of Interest</label><select class="custom-select" name="user[alliance_attributes][area_of_interest_id]" id="user_alliance_attributes_area_of_interest_id"><option value="">Please select</option></select></div></div><div class="col-md-6"><div class="form-group"><label class="control-label" for="user_alliance_attributes_website_url">Website url</label><input class="form-control" placeholder="Website url" type="url" name="user[alliance_attributes][website_url]" id="user_alliance_attributes_website_url"></div></div></div><div class="row"><div class="col-md-6"><div class="form-group"><label class="control-label" for="user_alliance_attributes_facebook_url">Facebook url</label><input class="form-control" placeholder="Facebook url" type="url" name="user[alliance_attributes][facebook_url]" id="user_alliance_attributes_facebook_url"></div></div><div class="col-md-6"><div class="form-group"><label class="control-label" for="user_alliance_attributes_twitter_url">Twitter url</label><input class="form-control" placeholder="Twitter url" type="url" name="user[alliance_attributes][twitter_url]" id="user_alliance_attributes_twitter_url"></div></div></div><div class="form-group row" id="501c_doc_2"><label class="control-label col-md-12 text-left">Charity Verification Document</label><div class="col-md-10 col-sm-9"></div></div><div style="margin-bottom: 10px" class="panel-body"><div class="input-group"><input id="uploadFile" class="form-control" placeholder="Choose File" disabled="disabled"/><div class="input-group-btn browse-file"><div class="fileUpload btn btn-success"><span><i class="glyphicon glyphicon-upload"></i> Browse</span><input id="uploadBtn" type="file" name="user[alliance_attributes][verification_doc]" class="upload required" /></div></div></div></div><div class="form-group"><label for="comment">Description</label><textarea class="form-control required" rows="5" name="user[alliance_attributes][description]" id="comment"></textarea></div><div class="form-group row" id="501c_doc_2"><label class="control-label col-md-12 text-left">Charity Logo</label><div class="col-md-10 col-sm-9"></div></div><div class="panel-body"><div class="input-group"><input id="uploadFile1" class="form-control" placeholder="Choose File" disabled="disabled"><div class="input-group-btn"><div class="fileUpload btn btn-success"><span><i class="glyphicon glyphicon-upload"></i> Browse</span><input id="uploadBtn1" type="file" name="user[alliance_attributes][logo]" class="upload" /></div></div></div></div>'
        $("#charity_form").html(charity_html);

        $.each(response, function(key,value) {
          $('#user_alliance_attributes_area_of_interest_id').append($('<option>', {
            value: value.id,
            text : value.name
          }));
        });
      }
    });

  });

  //   $(document).on('click','#customRadioInline2', function() {
  //   $.ajax({
  //     method: 'GET',
  //     url: '/area_of_interest',
  //     data: { interest_type: $(this).val() },
  //     success: function(response){
  //       var charity_html =  '<div id="charity_attributes"><div class="row"><div class="col-md-6"><div class="form-group"><label class="control-label" for="user_alliance_attributes_area_of_interest_id">Areas of Interest</label><select class="custom-select" name="user[alliance_attributes][area_of_interest_id]" id="user_alliance_attributes_area_of_interest_id"><option value="">Please select</option></select></div></div><div class="col-md-6"><div class="form-group"><label class="control-label" for="user_alliance_attributes_website_url">Website url</label><input class="form-control" placeholder="Website url" type="url" name="user[alliance_attributes][website_url]" id="user_alliance_attributes_website_url"></div></div></div><div class="row"><div class="col-md-6"><div class="form-group"><label class="control-label" for="user_alliance_attributes_facebook_url">Facebook url</label><input class="form-control" placeholder="Facebook url" type="url" name="user[alliance_attributes][facebook_url]" id="user_alliance_attributes_facebook_url"></div></div><div class="col-md-6"><div class="form-group"><label class="control-label" for="user_alliance_attributes_twitter_url">Twitter url</label><input class="form-control" placeholder="Twitter url" type="url" name="user[alliance_attributes][twitter_url]" id="user_alliance_attributes_twitter_url"></div></div></div><div class="row"><div class="col-md-6"><div class="form-group"><label class="control-label" for="user_alliance_attributes_google_plus_url">Google plus url</label><input class="form-control" placeholder="Google Plus url" type="url" name="user[alliance_attributes][gplus_url]" id="user_alliance_attributes_gplus_url"></div></div></div><div class="form-group"><label class="control-label col-md-10 text-left">Charity Verification Document</label><div class="input-group"><input id="uploadFile" class="form-control" placeholder="Choose File" disabled="disabled"/><div class="input-group-btn browse-file"><div class="fileUpload btn btn-success"><span><i class="glyphicon glyphicon-upload"></i>Browse</span><input id="uploadBtn" type="file" name="user[alliance_attributes][verification_doc]" class="upload required" /></div></div></div></div> <div class="form-group"><label for="comment">Description</label><textarea class="form-control" rows="5" name="user[alliance_attributes][description]" id="comment"></textarea></div><div class="form-group row" id="501c_doc_2"><label class="control-label col-md-12 text-left">Vendor Logo</label><div class="col-md-10 col-sm-9"></div></div><div class="panel-body"><div class="input-group"><input id="uploadFile1" class="form-control" placeholder="Choose File" disabled="disabled"><div class="input-group-btn"><div class="fileUpload btn btn-success"><span><i class="glyphicon glyphicon-upload"></i> Browse</span><input id="uploadBtn1" type="file" name="user[alliance_attributes][logo]" class="upload" /></div></div></div></div>'
  //       $("#charity_form").html(charity_html);

  //       $.each(response, function(key,value) {
  //         $('#user_alliance_attributes_area_of_interest_id').append($('<option>', {
  //           value: value.id,
  //           text : value.name
  //         }));
  //       });
  //     }
  //   });

  // });

  $(document).on('click','#customRadioInline3', function() {
    // $.ajax({
    //   method: 'GET',
    //   url: '/charities_list',
    //   success: function(response){
    //     console.log(response, "www")
        // var charity_html =  '<div id="charity_attributes"><br><div class="form-group" style="margin-bottom: 10px;"><label style="margin-bottom: 2px;">Select Charity</label><select class="form-control required" name="user[charity_id]" id="charity_info"><option value="">Select Charity</option></select></div><div style="margin-bottom: 10px;" class="row"><div class="col-md-12"><label style="margin-bottom: 10px;">Profile photo</label><div class="input-group"><input id="uploadFile" class="form-control" placeholder="Choose File" disabled="disabled"/><div class="input-group-btn browse-file"><div class="fileUpload btn btn-success"><span><i class="glyphicon glyphicon-upload"></i> Browse</span><input id="uploadBtn" type="file" name="user[profile]" accept="image/png, image/jpeg" class="upload required" /></div></div></div></div></div></div>'

        var charity_html =  '<div id="charity_attributes"><br><div style="margin-bottom: 10px;" class="row"><div class="col-md-12"><label style="margin-bottom: 10px;">Profile photo</label><div class="input-group"><input id="uploadFile" class="form-control" placeholder="Choose File" disabled="disabled"/><div class="input-group-btn browse-file"><div class="fileUpload btn btn-success"><span><i class="glyphicon glyphicon-upload"></i> Browse</span><input id="uploadBtn" type="file" name="user[profile]" accept="image/png, image/jpeg" class="upload required" /></div></div></div></div></div></div>'
        $("#charity_form").html(charity_html);
          
        // var c = [];

        // $.each(response, function(key,value) {
        //   c.push({
        //     value: value.id,
        //     text : value.name.toUpperCase()
        //   })
        //   $('#charity_info').append($('<option>', {
        //     value: value.id,
        //     text : value.name.toUpperCase()
        //   }));
        // });
      // }
    // });
  });

  $(document).on('change','.country-select', function() {
    var country_code = $(this).val();
    $.ajax({
      method: 'POST',
      url: '/states',
      data: {country_code: country_code},
      success: function(response){
        if ($.isEmptyObject(response.states)) {
          $("#state_div").html('<input class="form-control" placeholder="State" type="text" name="user[address_state]" id="user_address_state">');
          $("#city_div").html('<input class="form-control" placeholder="City" type="text" name="user[address_city]" id="user_address_city">');
        }
        else {
          $("#state_div").html('<select class="custom-select state-select required" name="user[address_state]"><option value="">Please select</option></select>');
          if ($.isEmptyObject(response.cities)) {
            $("#city_div").html('<input class="form-control" placeholder="City" type="text" name="user[address_city]" id="user_address_city">');
          }else{
            $("#city_div").html('<select class="custom-select city-select required" name="user[address_city]"> <option value="">Please select</option> </select>');
          }
          $('.state-select').html("");
          $('.city-select').html("");
          $.each(response.states, function(key,value) {
            $('.state-select').append($('<option>', {
              value: key,
              text : value
            }));
          });
          $.each(response.cities, function(key,value) {
            $('.city-select').append($('<option>', {
              value: key,
              text : value
            }));
          });
        }
      }
    });
  });

  $(document).on('change','.state-select', function() {
    var country_code = $('.country-select').val();;
    var state_code = $(this).val();
    $.ajax({
      method: 'POST',
      url: '/cities',
      data: {state_code: state_code, country_code: country_code},
      success: function(response){
        $('.city-select').html("");
        $.each(response.cities, function(key,value) {
          $('.city-select').append($('<option>', {
            value: key,
            text : value
          }));
        });
      }
    });
  });

  $(document).on('change','.campaign-country-select', function() {
    var country_code = $(this).val();
    $.ajax({
      method: 'POST',
      url: '/states',
      data: {country_code: country_code},
      success: function(response){
        if ($.isEmptyObject(response.states)) {
          $("#state_div").html('<input class="form-control" placeholder="State" type="text" name="campaign[address_state]" id="user_address_state">');
          $("#city_div").html('<input class="form-control" placeholder="City" type="text" name="campaign[address_city]" id="user_address_city">');
        }
        else {
          $("#state_div").html('<select class="custom-select campaign-state-select required" name="campaign[address_state]"><option value="">Please select</option></select>');
          if ($.isEmptyObject(response.cities)) {
            $("#city_div").html('<input class="form-control" placeholder="City" type="text" name="campaign[address_city]" id="user_address_city">');
          }else{
            $("#city_div").html('<select class="custom-select campaign-city-select required" name="campaign[address_city]"> <option value="">Please select</option> </select>');
          }
          $('.campaign-state-select').html("");
          $('.campaign-city-select').html("");
          $.each(response.states, function(key,value) {
            $('.campaign-state-select').append($('<option>', {
              value: key,
              text : value
            }));
          });
          $.each(response.cities, function(key,value) {
            $('.campaign-city-select').append($('<option>', {
              value: key,
              text : value
            }));
          });
        }
      }
    });
  });

  $(document).on('change','.product-country-select, #product_address_country', function() {
    var country_code = $(this).val();
    $.ajax({
      method: 'POST',
      url: '/states',
      data: {country_code: country_code},
      success: function(response){
        if ($.isEmptyObject(response.states)) {
          $("#state_div").html('<input class="form-control" placeholder="State" type="text" name="product[address_state]" id="product_address_state">');
          $("#city_div").html('<input class="form-control" placeholder="City" type="text" name="product[address_city]" id="product_address_city">');
        }
        else {
          $("#state_div").html('<select class="custom-select product-state-select required" name="product[address_state]"></select>');
          if ($.isEmptyObject(response.cities)) {
            $("#city_div").html('<input class="form-control" placeholder="City" type="text" name="product[address_city]" id="product_address_city">');
          }else{
            $("#city_div").html('<select class="custom-select product-city-select required" name="product[address_city]"></select>');
          }
          $('.product-state-select, #product_address_state').html("");
          $('.product-city-select, #product_address_city').html("");
          $.each(response.states, function(key,value) {
            $('.product-state-select, #product_address_state').append($('<option>', {
              value: key,
              text : value
            }));
          });
          $.each(response.cities, function(key,value) {
            $('.product-city-select, #product_address_city').append($('<option>', {
              value: key,
              text : value
            }));
          });
        }
      }
    });
  });

  $(document).on('change','.product-state-select, #product_address_state', function() {
    var country_code = $('.product-country-select').val() || $('#product_address_country').val();
    var state_code = $(this).val();
    $.ajax({
      method: 'POST',
      url: '/cities',
      data: {state_code: state_code, country_code: country_code},
      success: function(response){
        $('.product-city-select, #product_address_city').html("");
        $.each(response.cities, function(key,value) {
          $('.product-city-select, #product_address_city').append($('<option>', {
            value: key,
            text : value
          }));
        });
      }
    });
  });

  $(document).on('change','.campaign-state-select', function() {
    var country_code = $('.campaign-country-select').val();;
    var state_code = $(this).val();
    $.ajax({
      method: 'POST',
      url: '/cities',
      data: {state_code: state_code, country_code: country_code},
      success: function(response){
        $('.campaign-city-select').html("");
        $.each(response.cities, function(key,value) {
          $('.campaign-city-select').append($('<option>', {
            value: key,
            text : value
          }));
        });
      }
    });
  });

  $('.digg_pagination .pagination .previous_page').html("<i class='fa fa-angle-left'></i>");
  $('.digg_pagination .pagination .next_page').html("<i class='fa fa-angle-right'></i>");

  $(document).on('click','.login-alert', function() {
    swal({
      title: "Login required!",
    });
  });

  $(document).on('click','.donate-submit', function() {
    var path = $( '#campaign-donation-form' ).attr( 'action' );
    var data =  new FormData( $('#campaign-donation-form')[0] );
    $.ajax({
      method: 'POST',
      url: path,
      processData: false,
      contentType: false,
      data: data,
      success: function (response) {
        var data = response.campaign_donation;
        data.campaignId = data.campaign_id;
        data.goalReached = response.goalReached;
        data.charity = response.charity;
        data.charityId = response.charityId;
        if (response.status == "ok") {
          App.transferTokens(data);
        } else {
          $('#donate-msgs').html("<div class='shadow-lg alert alert-danger alert-dismissible fade show' role='alert'><button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>×</span></button></div>");
          if ( $.isArray(response.message) ) {
            $.each( response.message, function( index, error ) {
              $("#donate-msgs").find(".shadow-lg").append(
                $('<li>').html( error ).addClass('li-bullets')
              );
            });
          }
        }
      },
      error: function (xhr, ajaxOptions, thrownError) {
        swal('Could not complete transaction', 'Please try again', 'error');
      }
    });
  });


  $('#open_number').click(function(){
    var val = $(this).val()
    $('#volunteer_id').val(val)
    $('#hours').val('')
  })


  $(document).on('click','.volunteer-submit', function() {
    var path = $( '#volunteers-contribution-form' ).attr( 'action' );
    var data =  new FormData( $('#volunteers-contribution-form')[0] );
    $.ajax({
      method: 'POST',
      url: path,
      processData: false,
      contentType: false,
      data: data,
      success: function (response) {
        if (response.status == "ok") {
          $('#volunteerModal').modal('toggle');
          signUpVolunteerCampaign(response);
        }else {
          $('#volunteer-msgs').html("<div class='shadow-lg alert alert-danger alert-dismissible fade show' role='alert'><button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>×</span></button></div>");
          if ( $.isArray(response.message) ) {
            $.each( response.message, function( index, error ) {
              $("#volunteer-msgs").find(".shadow-lg").append(
                $('<li>').html( error ).addClass('li-bullets')
              );
            });
          }
        }
      },
      error: function (xhr, ajaxOptions, thrownError) {

      }
    });
  });

  $(document).on('click','.resource-submit', function() {
    var path = $( '#resource-donation-form' ).attr( 'action' );
    var data =  new FormData( $('#resource-donation-form')[0] );
    $.ajax({
      method: 'POST',
      url: path,
      processData: false,
      contentType: false,
      data: data,
      success: function (response) {
        if (response.status == "ok") {
          $('#inkindModal').modal('toggle');
          inKindDonation(response);
        }else {
          $('#resource-msgs').html("<div class='shadow-lg alert alert-danger alert-dismissible fade show' role='alert'><button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>×</span></button></div>");
          if ( $.isArray(response.message) ) {
            $.each( response.message, function( index, error ) {
              $("#resource-msgs").find(".shadow-lg").append(
                $('<li>').html( error ).addClass('li-bullets')
              );
            });
          }
        }
      },
      error: function (xhr, ajaxOptions, thrownError) {

      }
    });
  });

  $(document).on('click','.project-delete-alert', function() {
    swal({
      title: "Are you sure?",
      text: "Once deleted, you will not be able to recover this project!",
      icon: "warning",
      buttons: true,
      dangerMode: true,
    }).then(function(willDelete) {
      if (willDelete) {
        $.ajax({
          url: '/campaigns/'+$('.project-delete-alert').data('campaign-id'),
          dataType: "JSON",
          method: "DELETE",
          success: function() {
            location.reload();
          }
        });
      } else {
        swal("Your project is safe!");
      }
    });
  });


  $(document).on('click','.product-delete-alert', function() {
    swal({
      title: "Are you sure?",
      text: "Once deleted, you will not be able to recover this product!",
      icon: "warning",
      buttons: true,
      dangerMode: true,
    }).then(function(willDelete) {
      if (willDelete) {
        $.ajax({
          url: '/products/'+$('.product-delete-alert').data('product-id'),
          dataType: "JSON",
          method: "DELETE",
          success: function() {
            location.reload();
          }
        });
      } else {
        swal("Your product is safe!");
      }
    });
  });

  $(document).on('click','.set_vote', function() {
    var campaign_id = $(this).data('campaign-id');
    var product_id = $(this).data('product-id');
    $.ajax({
      method: 'POST',
      url: '/votes',
      data: {campaign_id: campaign_id, product_id: product_id},
      success: function(response){
        $('#vote_'+response.entity.id).text(response.count+' Votes');
        swal("", response.message, response.status);
      }
    });
  });

  var images  = []
  $(document).on('change',".image_button",function(){
    var rm_id = $(this).parent().next().attr('id')
    readFile(this, rm_id)
    // var reader = new FileReader();

  })

  $(document).on('change',"#product_media",function(){
    readProductFile(this)
  })

  $(document).on('click',"#rm_img_btn_blk",function(){
    // alert('ssssssssssssssssssssss333333')
    var rem_ele = $(this).prev().attr('id')
    console.log("sssssss", rem_ele)
    $(".campaign-images-list [id*="+rem_ele+"]").remove();
  })

  function readProductFile(input) {
    // $(".newly-added-product-images").remove();
    $.each(input.files, function(i, file) {
      if (input.files && input.files[i]) {
        var reader = new FileReader();
        reader.onload = function (e) {
          $(".product-images-list").append('<span class=\"newly-added-product-images\"><i class=\"fa fa-times-circle-o close-icon new-added-product-image\"></i><img src="'+e.target.result+'" class="img-thumbnail"></span>')
        };
        reader.readAsDataURL(input.files[i]);
      }
    });
  }

  function readFile(input, rm_id) {
    console.log(rm_id, "wwwwwwwww")
    $(".campaign-images-list [id*="+rm_id+"]").remove();
    // $(".newly-added-q-images").remove();
    $.each(input.files, function(i, file) {
      // if(i == 0) {
        // if (input.files && input.files[i]) {
        //   var reader = new FileReader();
        //   reader.onload = function (e) {
        //     $(".campaign-images-list").append('<span class=\"newly-added-q-images\"><img src="'+e.target.result+'" class="img-thumbnail"></span>')
        //   };
        //   reader.readAsDataURL(input.files[i]);
        // }
      // }else{
        if (input.files && input.files[i]) {
          var reader = new FileReader();
          reader.onload = function (e) {
            $(".campaign-images-list").append('<span id="'+rm_id+'" class=\"newly-added-q-images\"><img src="'+e.target.result+'" class="img-thumbnail"></span>')
          };
          reader.readAsDataURL(input.files[i]);
        }
      // }
    });
  }

  $(document).on('click',".new-added-image",function(){
    this.parentElement.remove();
    if ($(this).data('id')) {
      $.ajax({
        url: '/campaigns/'+$(this).data('id')+'/destroy_campaign_media',
        dataType: "JSON",
        method: "DELETE",
        success: function() {

        }
      });
    }
  })

  $(document).on('click',".new-added-product-image",function(){
    this.parentElement.remove();
    if ($(this).data('id')) {
      $.ajax({
        url: '/products/'+$(this).data('id')+'/destroy_product_media',
        dataType: "JSON",
        method: "DELETE",
        success: function() {

        }
      });
    }
  })
});

function showMsg(id){
  var id = id;
  $.ajax({
    url: "/volunteers/"+id+"/get_volunteer",
    type: "PUT",
    success: function (response) {
      console.log(response)
      $('#volunteer-msg').html(response.description);
    }
  })
}

function showDescription(id){
  var id = id;
  console.log(id);
  $.ajax({
    url: "/campaigns/"+id+"/get_need",
    type: "GET",
    success: function (response) {
      console.log(response)
      $('#need-des').html(response.description);
    }
  })
}

function allianceFilter(country){
  $.ajax({
    url: "/charities",
    type: "GET",
    data: {
            country: country, 
            search: $('#search').val()
          }
    // success: function (response) {
    //   console.log(response)
    //   $('#need-des').html(response.description);
    // }
  })
}

function productFilter(){
  $.ajax({
    url: "/products",
    type: "GET",
    data: {
            product_category:  $('#product_category').val(), 
            country: $('#country').val(),
            search: $('#search').val()
          }
  })
}

function vendorFilter(country){
  $.ajax({
    url: "/vendors",
    type: "GET",
    data: {
            country: country, 
            search: $('#search').val()
          }
  })
}

$(document).on("change", "#uploadBtn", function () {
  $("#uploadFile").val(this.value.substring(12));
});

$(document).on("change", "#uploadBtn1", function () {
  //console.log("Chnaged", this.value.substring(12))

  $("#uploadFile1").val(this.value.substring(12));
});

$(document).on("change", "#add_profile", function () {
  console.log("Chnaged", this.value.substring(12))
  $("#add_profile").val(this.value.substring(12));
});

function campaignFilter() {
  $.ajax({
    url: "/campaigns",
    type: "GET",
    data: {
            campaign_category:  $('#campaign_category').val(), 
            country: $('#country').val(),
            search: $('#search').val()
          }
  })
}


function submitInterest(id, name) {
  console.log(id, "ID")
  toastr.info(name.slice(0, 30).toLowerCase()+'...', "Request submitted")
  $.ajax({
    url: '/volunteer_interest/'+id,
    method: 'GET',
    success: function(res){
      if(res.data.status === 200){
        window.location.reload();
      }
    }
  })
}
