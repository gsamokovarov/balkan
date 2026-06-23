module.exports = {
  darkMode: "media",
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/tailwind/**/*.css",
    "./app/javascript/**/*.js",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter", "sans-serif"],
      },
      boxShadow: {
        brutal: "4px 4px #000",
        "brutal-md": "6px 6px #000",
      },
      colors: {
        current: "currentColor",
        x: {
          cyan: "#B1E7F6",
          lime: "#90EE90",
          purple: "#C4A1FF",
          yellow: "#FDF2B3",
          magenta: "#FFB2EF",
          green: "#7FBC8C",
          orange: "#F6C945",
        },
      },
      typography: {
        DEFAULT: {
          css: {
            a: {
              textDecoration: "none",
            },
            img: {
              borderWidth: "2px",
              borderColor: "black",
              borderRadius: "0.375rem",
            },
          },
        },
      },
    },
  },
}
