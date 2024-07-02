import * as React from 'react';
import { Text, TextInput, View } from 'react-native';

import { LayoutAvoidingView, LayoutContextView, useLayoutContext } from 'react-native-layout-context';

const ContentView = React.memo(() => {
  const layout = useLayoutContext();
  return (
    <LayoutAvoidingView style={{ flexGrow: 1, alignSelf: 'stretch', justifyContent: 'center', alignItems: 'center', gap: 16 }}>
      <View style={{ justifyContent: 'center', alignItems: 'center', gap: 16 }}>
        <Text style={{ fontSize: 24, color: 'white', fontWeight: '600', marginBottom: 16 }}>{layout}</Text>
        <TextInput style={{ width: 200, height: 48, backgroundColor: 'white', borderRadius: 8, fontSize: 18, paddingHorizontal: 16 }} placeholder='Tap me' />
        <TextInput style={{ width: 200, height: 48, backgroundColor: 'white', borderRadius: 8, fontSize: 18, paddingHorizontal: 16 }} placeholder='Tap me' />
      </View>
    </LayoutAvoidingView>
  )
});

export default function App() {
  return (
    <View style={{ flexDirection: 'row', flexGrow: 1, flexBasis: 0, alignItems: 'stretch' }}>
      <LayoutContextView name="context-1" style={{ flexGrow: 1, flexBasis: 0, backgroundColor: 'red', flexDirection: 'column' }}>
        <ContentView />
      </LayoutContextView>
      <LayoutContextView name="context-2" style={{ flexGrow: 1, flexBasis: 0, backgroundColor: 'blue', flexDirection: 'column' }}>
        <ContentView />
      </LayoutContextView>
    </View>
  );
}