import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ReactNativeLayoutContextViewProps } from './ReactNativeLayoutContext.types';

const NativeView: React.ComponentType<ReactNativeLayoutContextViewProps> =
  requireNativeViewManager('ReactNativeLayoutContext');

export default function ReactNativeLayoutContextView(props: ReactNativeLayoutContextViewProps) {
  return <NativeView {...props} />;
}
