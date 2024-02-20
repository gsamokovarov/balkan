# Preview all emails at http://localhost:3000/rails/mailers/subscriber
class SelectionPreview < ActionMailer::Preview
  Speaker = Data.define :name, :email, :talk

  def waitinglist_email
    speaker = Speaker.new name: "Christoph Lipautz", email: "christoph@lipautz.org", talk: "Testing, in Practice"

    SelectionMailer.waitinglist_email(speaker).deliver_now
  end
end
