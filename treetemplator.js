// Generated by CoffeeScript 1.7.1
(function() {
  var State, Templator, create, isArray, isObjArr, isObject;

  isObject = function(x) {
    return typeof x === 'object' && x && x.constructor === Object;
  };

  isArray = function(x) {
    return typeof x === 'object' && x && x.constructor === Array;
  };

  isObjArr = function(x) {
    return isArray(x) || isObject(x);
  };

  State = (function() {
    function State() {
      this.level = -1;
      this.counters = [];
    }

    State.prototype.up = function() {
      this.level++;
      return this.counters.push(0);
    };

    State.prototype.down = function() {
      this.level--;
      return this.counters.pop();
    };

    State.prototype.next = function() {
      return this.counters[this.level]++;
    };

    return State;

  })();

  Templator = (function() {
    var replace, replaceCounters;

    function Templator(opts) {
      var _base;
      this.opts = opts;
      if (this.opts == null) {
        this.opts = {};
      }
      if ((_base = this.opts).defaultDelimeter == null) {
        _base.defaultDelimeter = '';
      }
    }

    replace = function(tpl, variable, value) {
      var r;
      if (variable == null) {
        variable = '\\w*';
      }
      if (value == null) {
        value = '';
      }
      if (tpl != null) {
        r = new RegExp("\\$\\{" + variable + "\\}", 'g');
        return tpl.replace(r, value.toString());
      }
    };

    replaceCounters = function(tpl, state) {
      var i, j, r, _i, _ref;
      if (tpl != null) {
        j = 0;
        for (i = _i = _ref = state.counters.length - 1; _ref <= 0 ? _i <= 0 : _i >= 0; i = _ref <= 0 ? ++_i : --_i) {
          r = new RegExp("\\$" + j, 'g');
          tpl = tpl.replace(r, state.counters[i]);
          j++;
        }
        return tpl;
      }
    };

    Templator.prototype.apply = function(data, tpl, state) {
      var array, item, p, substitution, t;
      if (state == null) {
        state = new State();
      }
      if (isArray(data)) {
        state.up();
        array = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = data.length; _i < _len; _i++) {
            item = data[_i];
            state.next();
            _results.push(this.apply(item, tpl, state));
          }
          return _results;
        }).call(this);
        state.down();
        return array.join((tpl != null ? tpl._delimeter : void 0) || this.opts.defaultDelimeter);
      } else {
        t = typeof tpl === 'object' ? tpl._ : tpl;
        if (isObject(data)) {
          for (p in data) {
            if (!(data.hasOwnProperty(p) && p[0] !== '_')) {
              continue;
            }
            substitution = isObjArr(data[p]) ? this.apply(data[p], tpl[p], state) : data[p];
            t = replace(t, p, substitution);
          }
          t = replaceCounters(t, state);
        } else {
          t = t != null ? t.replace(/\$\{\}/g, data) : data.toString();
          t = replaceCounters(t, state);
        }
        return t = replace(t);
      }
    };

    return Templator;

  })();

  create = function(opts) {
    return new Templator(opts);
  };

  if (typeof exports === 'object') {
    exports.Templator = Templator;
    exports.create = create;
  } else if (typeof define === 'function' && define.amd) {
    define({
      Templator: Templator,
      create: create
    });
  }

}).call(this);

//# sourceMappingURL=treetemplator.map