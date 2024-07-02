import * as React from 'react';
import { StyleSheet, Text, TextInput, View } from 'react-native';

import { LayoutContextView } from 'react-native-layout-context';

const ContentView = React.memo(() => {
  return (
    <View style={{ flexGrow: 1, alignSelf: 'stretch', justifyContent: 'center', alignItems: 'center' }}>
      <TextInput style={{ width: 200, height: 48, backgroundColor: 'white', borderRadius: 8, fontSize: 18, paddingHorizontal: 16 }} placeholder='Tap me' />
    </View>
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
