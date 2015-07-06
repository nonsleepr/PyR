
context("Test base functions")

test_that("python.call works with different arguments", {
  python.exec("def foo(var):\n    return var")
  expect_equal(python.call("foo", 100), "100")
  python.exec("def foo(bar, baz):\n    return (bar, baz)")
  #expect_equal(python.call("foo", 100, baz = 200), c(100, 200))
  expect_equal(python.call("foo", 100, baz = 200), "[100, 200]")
})
