require 'test_helper'

class SendmailTest < ActionMailer::TestCase
  test "forgot_password" do
    @expected.subject = 'Sendmail#forgot_password'
    @expected.body    = read_fixture('forgot_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Sendmail.create_forgot_password(@expected.date).encoded
  end

end
