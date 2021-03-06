var Store = require('./store');
var HttpAPI = require('./httpAPI');
var constants = require('./constants');
var Dispatcher = require('./dispatcher');
var StateMixin = require('./mixins/stateMixin');
var ActionCreators = require('./actionCreators');
var stores = [];

module.exports = {
  getStores: getStores,
  createStore: createStore,
  createHttpAPI: createHttpAPI,
  createHTTPAPI: createHttpAPI, // For those who really care about correct casing
  createConstants: createConstants,
  createStateMixin: createStateMixin,
  createActionCreators: createActionCreators
};

function getStores() {
  return stores;
}

function createStore(options) {
  var store = new Store(defaults(this, options));
  stores.push(store);
  return store;
}

function createHttpAPI(options) {
  return new HttpAPI(defaults(this, options));
}

function createConstants(obj) {
  return constants(obj);
}

function createActionCreators(options) {
  return new ActionCreators(defaults(this, options));
}

function createStateMixin(options) {
  return new StateMixin(defaults(this, options));
}

function defaults(marty, options) {
  options || (options = {});

  if (!options.dispatcher) {
    options.dispatcher = Dispatcher.getCurrent();
  }

  return options;
}