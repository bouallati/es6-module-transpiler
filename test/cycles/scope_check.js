import odd from './b';

export default function even(n) {
  // below should be rewritten...
  return n === 0 || odd(n - 1);
}

// below should not
function foo(odd) {
}

// nor should this
function bar() {
  var odd;
  console.log(odd);
}