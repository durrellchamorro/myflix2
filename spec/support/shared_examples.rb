shared_examples "require_sign_in" do
  it "redirects to the login page" do
    clear_current_user
    action
    expect(response).to redirect_to(:login)
  end
end

shared_examples "require_admin" do
  it "redirects the regular user to the home path" do
    set_current_user
    action

    expect(response).to redirect_to home_path
    expect(flash[:danger]).to be_present
  end
end
