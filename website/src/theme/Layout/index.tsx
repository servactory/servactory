import React from 'react';
import inject from '@vercel/analytics';

import Layout from '@theme-original/Layout';
import type {Props} from '@theme/Layout';

// This component is only used to test for CSS insertion order
// import './styles.module.css';

const isDev = process.env.NODE_ENV === 'development';

if (!isDev) {
  inject();
}

export default function LayoutWrapper(props: Props): JSX.Element {
  return <Layout {...props} />;
}
