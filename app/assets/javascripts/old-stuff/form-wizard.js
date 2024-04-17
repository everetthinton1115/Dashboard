(function ($) {
    "use strict";

    // Form Wizard
    if ($.isFunction($.fn.bootstrapWizard))
    {
        $('#rootwizard').bootstrapWizard({
            tabClass: 'nav wizard-steps',
            onTabShow: function ($tab, $navigation, index)
            {
                console.log('index is = ' + index);
                $tab.prevAll().addClass('completed');
                $tab.nextAll().removeClass('completed');
                $tab.removeClass('completed');
            }

        });

        $(".validate-form-wizard").each(function (i, formwizard)
        {
            var $this = $(formwizard);
            var $progress = $this.find(".steps-progress div");

            var $validator = $this.validate({
                rules: {
                    username: {
                        required: true,
                        minlength: 3
                    },
                    password: {
                        required: true,
                        minlength: 3
                    },
                    confirmpassword: {
                        required: true,
                        minlength: 3
                    },
                    email: {
                        required: true,
                        email: true,
                        minlength: 3
                    },
                    logo: {
                      required: true
                    }
                }
            });

            // Validation
            var checkValidaion = function (tab, navigation, index)
            {
                var goal = $('.goal').val();
                var vols = $('.num_vol').val();
                var hrs = $('.num_hrs').val();

                var profile = $('#add_profile').val();
                
                // if(profile !== ''){
                //     $('#logo_err').addClass('hide_msg')
                //     $('#logo_err').removeClass('show_msg')                    
                //     //return true;
                //     //$('.hide_msg').removeClass('show_msg')
                // }else{
                //     //alert("sssssssss")
                //     $('#logo_err').addClass('show_msg')
                //     $('#logo_err').removeClass('hide_msg')
                //     return false;
                // }
                console.log(index, goal, vols, hrs)
                if ($this.hasClass('validate'))
                {
                  var $valid = $this.valid();
                  if (!$valid) {
                    $validator.focusInvalid();
                    return false;
                  }

                  //Click event to scroll to top

                }

                if($('#user_password').val()!== $('#user_password_confirmation').val()){
                  // alert($('#user_password').val() +"-------"+$('#user_password_confirmation').val())
                  toastr.error("Password and Confirm must be the same")
                  return false;
                }
                // if((index === 2) && (goal != "") && (vols != "") && (hrs != "")){
                //     console.log(tab, navigation, index)
                //   if((goal > 0) && (vols > 0) && (hrs > 0)){
                //     if(goal >= vols * hrs){
                //       console.log(goal, "SSSSSSSSSSSSSS")
                //       $('.show_msg').addClass('hide_msg')
                //       $('.hide_msg').removeClass('show_msg')                      
                //       return true;
                //     }else{
                //       console.log(vols, hrs, "))))))")
                //       $('.hide_msg').addClass('show_msg')
                //       $('.show_msg').removeClass('hide_msg')
                //       return false;
                //     }
                //   }
                // }
                return true;
            };

            var checkPrevious = function(){
              return true;
            }
            $this.bootstrapWizard({
                tabClass: 'nav wizard-steps',
                onNext: checkValidaion,
                onPrevious: checkPrevious,
                onTabClick: checkValidaion,
                onTabShow: function ($tab, $navigation, index)
                {
                    $tab.removeClass('completed');
                    $tab.prevAll().addClass('completed');
                    $tab.nextAll().removeClass('completed');
                }
            });
        });
    }

})(jQuery);