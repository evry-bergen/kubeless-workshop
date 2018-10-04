module.exports = {
  foo: function (event, context) {
    console.log(event);
    return event.data;
  }
}
