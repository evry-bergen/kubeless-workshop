module.exports = {
  handler: function (event, context) {
    console.log(event);

    if (Math.random() > 0.2) {
      throw new Error('Failing :(');
    }

    const message = `Hello ${event.data || 'World'}`;

    return message;
  }
}
