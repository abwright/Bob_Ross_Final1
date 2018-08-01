require 'test_helper'

class CanvasControllerTest < ActionDispatch::IntegrationTest
  test "should get draw" do
    get canvas_draw_url
    assert_response :success
  end

end
