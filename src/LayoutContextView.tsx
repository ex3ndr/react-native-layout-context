import * as React from 'react';
import { ReactNativeLayoutContextViewProps } from './ReactNativeLayoutContext.types';
import ReactNativeLayoutContextView from './ReactNativeLayoutContextView';
import { LayoutContext } from './LayoutContext';

export const LayoutContextView = React.memo((props: ReactNativeLayoutContextViewProps) => {
    return (
        <LayoutContext.Provider value={props.name}>
            <ReactNativeLayoutContextView {...props} />
        </LayoutContext.Provider>
    )
});