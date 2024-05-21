import { validateWord } from "../../wordle.mjs"

describe("Test word validation for WORDLE", function () {
  it("A valid word", function () {
    expect(validateWord("apple")).toBe(true)
  })
  it("An invalid word", function () {
    expect(validateWord("x-ray")).toBe(false)
  })
  it("An invalid word", function () {
    expect(validateWord("h")).toBe(false)
  })
  it("An invalid word", function () {
    expect(validateWord("12345")).toBe(false)
  })
})
