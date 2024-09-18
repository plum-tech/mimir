import globals from "globals"
import pluginJs from "@eslint/js"


export default [
  {
    languageOptions: { globals: globals.node },
  },
  pluginJs.configs.recommended,
  {
    rules: {
      "no-unused-vars": "warn",
      "no-undef": "error"
    }
  },
  {
    ignores: [
      "timetable.test.local.js",
      "spec/support/wordle.spec.mjs"
    ]
  }
]
