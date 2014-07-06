// Generated by CoffeeScript 1.6.3
(function() {
  define(function() {
    var compare;
    return compare = function(a, b) {
      /*
      		Order:
      		-6: Constants, by value
      		-5: Symbolic constants, by label
      		-4: Variables, by label
      		-3: Power nodes, by base
      		-2: Multiplication nodes, by first child
      		-1: Addition nodes, by first child
      */

      if ((a.cmp != null) && (b.cmp != null)) {
        if (a.cmp === b.cmp) {
          return a.compareSameType(b);
        } else {
          return (a.cmp - b.cmp) / Math.abs(a.cmp - b.cmp);
        }
      } else {
        return 0;
      }
    };
  });

}).call(this);