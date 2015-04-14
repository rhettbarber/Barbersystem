

# Module containing the methods useful for child IFRAME to parent window communication
module RespondsToParent

  # Executes the response body as JavaScript in the context of the parent window.
  # Use this method of you are posting a form to a hidden IFRAME or if you would like
  # to use IFRAME base RPC.
  def responds_to_parent(&block)
          logger.debug "******************************************************************************"
          logger.debug "******************************************************************************"
          logger.debug "******************************************************************************"
          logger.debug "******************************************************************************"
          logger.debug "******************************************************************************"
          logger.debug "******************************************************************************"
          logger.debug "******************************************************************************"
    yield

          if performed?
            # We're returning HTML instead of JS or XML now
            response.headers['Content-Type'] = 'text/html; charset=UTF-8'

            # Either pull out a redirect or the request body
            script =  if response.headers['Location']
                        #TODO: erase_redirect_results is missing in rails 3.0 has to be implemented
      #                  erase redirect
                        "document.location.href = #{location.to_s.inspect}"
                      else
                        response.body
                      end

            # Escape quotes, linebreaks and slashes, maintaining previously escaped slashes
            # Suggestions for improvement?
            script = (script || '').
              gsub('\\', '\\\\\\').
              gsub(/\r\n|\r|\n/, '\\n').
              gsub(/['"]/, '\\\\\&').
              gsub('</script>','</scr"+"ipt>')

            # Clear out the previous render to prevent double render
            response.request.env['action_controller.instance'].instance_variable_set(:@_response_body, nil)

            # Eval in parent scope and replace document location of this frame
            # so back button doesn't replay action on targeted forms
            # loc = document.location to be set after parent is updated for IE
            # with(window.parent) - pull in variables from parent window
            # setTimeout - scope the execution in the windows parent for safari
            # window.eval - legal eval for Opera
            render :text => "<html><body><script type='text/javascript' charset='utf-8'>
              var loc = document.location;
              with(window.parent) { setTimeout(function() { window.eval('#{script}'); if (typeof(loc) !== 'undefined') loc.replace('about:blank'); }, 1) };
              </script></body></html>".html_safe
          end
  end
  alias respond_to_parent responds_to_parent
end



#      RespondsToParent
#      ================
#
#      Adds responds_to_parent to your controller to respond to the parent document of your page.
#      Make Ajaxy file uploads by posting the form to a hidden iframe, and respond with
#      RJS to the parent window.
#
#      http://sean.treadway.info/responds-to-parent/
#
#
#      Example
#      =======
#
#      Controller:
#
#        class Test < ActionController::Base
#          def main
#          end
#
#          def form_action
#            # Do stuff with params[:uploaded_file]
#
#            responds_to_parent do
#              render :update do |page|
#                page << "alert($('stuff').innerHTML)"
#              end
#            end
#          end
#        end
#
#      main.rhtml:
#
#        <html>
#          <body>
#            <div id="stuff">Here is some stuff</div>
#
#            <form target="frame" action="form_action">
#              <input type="file" name="uploaded_file"/>
#              <input type="submit"/>
#            </form>
#
#            <iframe id='frame' name="frame"></iframe>
#          </body>
#        </html>