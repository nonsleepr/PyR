context("Test extended functions")

test_that("python.get_function returns function that works", {
  python.exec("def test_fn(a = 3, b = 4):\n    return a * b")
  test_fn <- python.get_function('test_fn')
  expect_true(is.function(test_fn))
  expect_equal(test_fn(), 12)
  expect_equal(test_fn(10, 20), 200)
  expect_equal(test_fn(a = 10), 40)
  expect_equal(test_fn(b = 10), 30)
})

test_that("python.get_class returns working Python class", {
  expect_is(PyStr <- python.get_class("str"), "refObjectGenerator")
  s <- PyStr("hello, {name}")
  expect_equal(s$format(name = "world"), "hello, world")
})
