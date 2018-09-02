// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

let socket = new Socket("/socket", {params: {token: window.userToken}})

const enableOrdersSocket = () => {
  socket.connect();

  const channel = socket.channel("orders:index", {})
  channel.join()
    .receive("ok", resp => null)
    .receive("error", resp => { console.log("Unable to join", resp) })

  channel.on("new_order", newOrder);
  channel.on("update_order", updateOrder);
  channel.on("delete_order", deleteOrder);
}

const newOrder = ({ order }) => {
  $("#orders-tbody").prepend(order);
}

const updateOrder = ({ order_id, order }) => {
  $(`#orders-tbody tr[data-id='${order_id}']`).replaceWith(order);
}

const deleteOrder = ({ order_id }) => {
  $(`#orders-tbody tr[data-id='${order_id}']`).remove();
}

// export default socket
window.enableOrdersSocket = enableOrdersSocket;
