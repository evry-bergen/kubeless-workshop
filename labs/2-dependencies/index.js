'use strict';

const rq = require('request-promise-native');

module.exports = {
    weather: async function (event, context) {
        const location = event.data.location;

        if (!location) {
            throw new Error('You must provide a location.');
        }

        const response = await rq(`https://query.yahooapis.com/v1/public/yql?q=select item.condition from weather.forecast where woeid in (select woeid from geo.places(1) where text="${location}") and u="c"&format=json`);

        const results = JSON.parse(response).query.results;
        console.log(results);

        if (!results) {
          return `No forcast found for ${location}`;
        }

        const condition = results.channel.item.condition;
        console.log(condition);

        const { text, temp: temperature } = condition;
        return `It is ${temperature} celsius degrees in ${location} and ${text}`;
    }
}
