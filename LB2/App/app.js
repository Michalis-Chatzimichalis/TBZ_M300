// Calisto
// Einfache node.js Web-Applikation um zu demonstrieren, wie Apps in Container verfrachtet werden können
// Vorsicht: Ist nur zu Demo-zwecken erstellt worden (wird nicht gewartet)
'use strict';

var express = require('express'),
    app = express();

app.set('views', 'views');
app.set('view engine', 'pug');

app.get('/', function(req, res) {
    res.render('home.pug', {
  });
});

app.listen(8080);
module.exports.getApp = app;