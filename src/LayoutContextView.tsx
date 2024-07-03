import * as React from 'react';
import { ReactNativeLayoutContextViewProps } from './ReactNativeLayoutContext.types';
import ReactNativeLayoutContextView from './ReactNativeLayoutContextView';
import { LayoutContext } from './LayoutContext';
import { StyleProp, ViewStyle } from 'react-native';

export type LayoutContextViewProps = {
    name?: string | undefined;
    children?: React.ReactNode;
    style?: StyleProp<ViewStyle>;
};


export const LayoutContextView = React.memo((props: LayoutContextViewProps) => {
    const name = React.useMemo(() => props.name || 'key=' + Math.random(), []);
    return (
        <LayoutContext.Provider value={name}>
            <ReactNativeLayoutContextView {...props} name={name} />
        </LayoutContext.Provider>
    )
});