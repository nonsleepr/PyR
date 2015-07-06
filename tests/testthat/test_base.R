
context("Test base functions")

test_that("python.call works with different arguments", {
  python.exec("def foo(var):\n    return var")
  expect_equal(python.call("foo", 100), 100)
  expect_equal(python.call("foo", c(100, 200)), c(100, 200))
  python.exec("def foo(bar, baz):\n    return (bar, baz)")
  expect_equal(python.call("foo", 100, 200), c(100, 200))
  expect_equal(python.call("foo", bar = 100, baz = 200), c(100, 200))
})

test_that("python.eval returns results", {
  expect_equal(python.eval("1+1"), 2)
  expect_equal(python.eval("str(1+1)"), "2")
})

test_that("python.assign and python.get work together", {
  expect_equal(python.assign("v1", 100),            python.get("v1"))
  expect_equal(python.assign("V2", "abc"),          python.get("v2"))
  expect_equal(python.assign("V3", c(100, 200)),    python.get("v3"))
  expect_equal(python.assign("V4", list(a=1, b=2)), python.get("v4"))
})
