import * as React from 'react';

import { ReactNativeLayoutContextViewProps } from './ReactNativeLayoutContext.types';

export default function ReactNativeLayoutContextView(props: ReactNativeLayoutContextViewProps) {
  return (
    <>
      {props.children}
    </>
  );
}
