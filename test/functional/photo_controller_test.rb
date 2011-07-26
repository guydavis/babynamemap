require File.dirname(__FILE__) + '/../test_helper'
require 'photo_controller'

# Re-raise errors caught by the controller.
class PhotoController; def rescue_action(e) raise e end; end

class PhotoControllerTest < Test::Unit::TestCase
  def setup
    @controller = PhotoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
