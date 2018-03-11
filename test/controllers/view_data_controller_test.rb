require 'test_helper'

class ViewDataControllerTest < ActionDispatch::IntegrationTest
  setup do
    @view_datum = view_data(:one)
  end

  test "should get index" do
    get view_data_url
    assert_response :success
  end

  test "should get new" do
    get new_view_datum_url
    assert_response :success
  end

  test "should create view_datum" do
    assert_difference('ViewDatum.count') do
      post view_data_url, params: { view_datum: { content: @view_datum.content, data_type: @view_datum.data_type } }
    end

    assert_redirected_to view_datum_url(ViewDatum.last)
  end

  test "should show view_datum" do
    get view_datum_url(@view_datum)
    assert_response :success
  end

  test "should get edit" do
    get edit_view_datum_url(@view_datum)
    assert_response :success
  end

  test "should update view_datum" do
    patch view_datum_url(@view_datum), params: { view_datum: { content: @view_datum.content, data_type: @view_datum.data_type } }
    assert_redirected_to view_datum_url(@view_datum)
  end

  test "should destroy view_datum" do
    assert_difference('ViewDatum.count', -1) do
      delete view_datum_url(@view_datum)
    end

    assert_redirected_to view_data_url
  end
end
