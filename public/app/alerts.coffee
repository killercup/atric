$ ->
  $alerts = $ '#alerts'
  window.addAlert = ({msg, type}) ->
    $alerts.append div {class: "alert alert-#{type}"}, [
      button {type: 'button', class: 'close', 'data-dismiss': 'alert'}, '×'
      msg or 'Error'
    ]