## app/models/big_blue_button_conference.rb

Comment out the following line:

```rb
req_params = {
  :meetingID => conference_key,
  :name => title,
#       :voiceBridge => format("%020d", global_id),
  :attendeePW => settings[:user_key],
  :moderatorPW => settings[:admin_key],
  :logoutURL => (settings[:default_return_url] || "http://www.instructure.com"),
  :record => settings[:record] ? true : false,
  "meta_canvas-recording-ready-user" => recording_ready_user,
  "meta_canvas-recording-ready-url" => recording_ready_url(current_host)
}
```
