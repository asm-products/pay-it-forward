(function(){
  
  var pledges = function(){
    $("o-possum[include='/fragments/pledge_form']").on('possum:ready', function () {
      console.log('element possum:ready received');
      var $form = $('#new_pledge_form');

      $form.on('ajax:success', function(data, status, xhr){
        $form.find('#payment-errors').html('').addClass('hidden');
        Turbolinks.visit(status.url);
      });

      $form.on('ajax:error', function(xhr, status, error){
        $form.find('#payment-errors').html(status.responseJSON.join('<br>')).removeClass('hidden');
        $.rails.enableFormElements($form);
      });

      var stripeResponseHandler = function (status, response) {
        if (response.error) {
          $form.find('#pledge_form_stripe_auth_token').val(null);
          $form.find('#payment-errors').html(response.error.message).removeClass('hidden');
          $.rails.enableFormElements($form);
        } else {
          $form.find('#pledge_form_stripe_auth_token').val(response.id);
          $.rails.handleRemote($form);
        }
      };

      $form.bootstrapValidator({
        feedbackIcons: {
          valid: 'glyphicon glyphicon-ok',
          invalid: 'glyphicon glyphicon-remove',
          validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
          name: {
            selector: '[data-stripe="name"]',
            validators: {
              notEmpty: {
                message: 'Your full name is required'
              }
            }
          },
          email: {
            validators: {
              notEmpty: {
                message: 'Your email is required'
              },
              emailAddress: {
                message: 'Your value is not a valid email address'
              }
            }
          },
          credit_card_number: {
            selector: '[data-stripe="number"]',
            validators: {
              notEmpty: {
                message: 'Your credit card number is required'
              },
              creditCard: {
                message: 'Your credit card number is not valid'
              }
            }
          },
          expiration_month: {
            selector: '[data-stripe="exp_month"]',
            validators: {
              notEmpty: {
                message: "Your credit card's expiration month is required"
              },
              between: {
                min: 1,
                max: 12,
                message: 'Your expiration month must be between 1 and 12'
              }
            }
          },
          expiration_year: {
            selector: '[data-stripe="exp_year"]',
            validators: {
              notEmpty: {
                message: "Your credit card's expiration year is required"
              },
              greaterthan: {
                inclusive: true,
                value: function(value, validator, $field) {
                  return parseInt((new Date().getFullYear()+'').slice(-2), 10);
                },
                message: 'Your expiration year must not be expired'
              }
            }
          },
          credit_card_cvv: {
            selector: '[data-stripe="cvc"]',
            validators: {
              notEmpty: {
                message: "Your credit card's CVV is required"
              },
              cvv: {
                creditCardField: 'credit_card_number',
                message: 'The CVV number is not valid'
              }
            }
          },
          address_line1: {
            selector: '[data-stripe="address_line1"]',
            validators: {
              notEmpty: {
                message: 'Your billing address is required'
              }
            }
          },
          address_city: {
            selector: '[data-stripe="address_city"]',
            validators: {
              notEmpty: {
                message: 'Your billing address city is required'
              }
            }
          },
          address_state: {
            selector: '[data-stripe="address_state"]',
            validators: {
              notEmpty: {
                message: 'Your billing address state is required'
              }
            }
          },
          address_zip: {
            selector: '[data-stripe="address_zip"]',
            validators: {
              notEmpty: {
                message: 'Your billing address zip is required'
              },
              /* Zip Code validator currently fails unsupported countries, rather then skipping */
              /* https://github.com/nghuuphuoc/bootstrapvalidator/issues/1252 */
              /*zipCode: {
                country: 'address_country',
                message: 'The value is not valid %s postal code'
              }*/
            }
          },
          address_country: {
            selector: '[data-stripe="address_country"]',
            validators: {
              notEmpty: {
                message: 'Your billing address country is required'
              }
            }
          },

        }
      }).on('change', '[data-stripe="address_country"]', function(event) {
        $('#new_pledge').bootstrapValidator('revalidateField', 'address_zip');
      }).on('success.form.bv', function(event) {
        $form.find('#pledge_form_stripe_auth_token').val(null);
        $.rails.disableFormElements($form);
        Stripe.card.createToken($form, stripeResponseHandler);

        return false;
      });
    });
  };
  
  $(document).on('ready', pledges);
  $(document).on('page:load', pledges);
}());
