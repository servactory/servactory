// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/vsDark');

const isDev = process.env.NODE_ENV === 'development';

if (isDev) {
  require('dotenv').config({ path: './.env.local' });
}

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Servactory',
  titleDelimiter: '—',
  tagline: 'Service factory for Ruby applications',
  favicon: 'img/favicon.ico',

  // Set the production url of your site here
  url: 'https://servactory.com',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  // organizationName: 'afuno',
  // projectName: 'servactory',

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  // Even if you don't use internalization, you can use this field to set useful
  // metadata like html lang. For example, if your site is Chinese, you may want
  // to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'ru'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          path: 'docs',
          routeBasePath: '/',
          lastVersion: 'current',
          versions: {
            current: {
              label: '1.8',
              path: '/',
            },
          },
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl: 'https://github.com/afuno/servactory/blob/main/website/',
        },
        blog: false,
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
        sitemap: {
          changefreq: 'weekly',
          priority: 0.5,
          ignorePatterns: ['/tags/**'],
          filename: 'sitemap.xml',
        },
      }),
    ],
  ],

  plugins: [
    [
      '@docusaurus/plugin-client-redirects',
      {
        redirects: [
          {
            from: '/usage/call',
            to: '/usage/call-and-result',
          },
          {
            from: '/usage/input',
            to: '/usage/attributes/input',
          },
          {
            from: '/usage/output',
            to: '/usage/attributes/output',
          },
          {
            from: '/usage/internal',
            to: '/usage/attributes/internal',
          },
          {
            from: '/usage/result',
            to: '/usage/call-and-result',
          },
        ]
      }
    ]
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      metadata: [{name: 'keywords', content: 'ruby, rails, services, service-factory, servactory'}],
      // Replace with your project's social card
      // image: 'img/social-card.jpg',
      colorMode: {
        defaultMode: 'dark',
        disableSwitch: true,
        respectPrefersColorScheme: false,
      },
      algolia: {
        appId: process.env.ALGOLIA_APP_ID,
        apiKey: process.env.ALGOLIA_API_KEY,
        indexName: 'servactory',
      },
      navbar: {
        title: 'Servactory',
        // logo: {
        //   alt: 'Servactory',
        //   src: 'img/logo.svg',
        // },
        items: [
          {
            type: 'search',
            position: 'left'
          },
          {
            href: 'https://github.com/afuno/servactory',
            label: 'GitHub',
            position: 'right',
          },
          {
            type: 'docsVersionDropdown',
            position: 'right',
            dropdownActiveClassDisabled: true,
          },
          {
            type: 'localeDropdown',
            position: 'right',
          },
        ],
      },
      // docs: {},
      // footer: {},
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
        additionalLanguages: ['ruby'],
      },
    }),
};

module.exports = config;
