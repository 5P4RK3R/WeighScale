import 'dart:core';

range(start, end, step) {
  var arr = [], len = 0;

  step = step == null ? 1.0 : step;

  if (arr.length == 1) {
    len = start;
    start = 0.0;
    end = start;
  } else {
    start = start == null ? 1.0 : start;
    end = end == null ? 1.0 : end;
    len = end - start;
  }

  var i = 0.0;
  while (i < len) {
    arr.add((start + i * step));

    i += 0.05;
  }
  return arr;
}
