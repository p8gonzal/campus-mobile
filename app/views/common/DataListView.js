import React from 'react'
import { FlatList } from 'react-native'
import DiningItem from '../home/cards/dining/DiningItem'
import LinksItem from '../home/cards/links/LinksItem'
import css from '../../styles/css'

/**
 * Generic listview used by DataListCard
 * @param {Object[]} data
 * @param {Number} rows Max number of rows
 * @param {Boolean} scrollEnabled
 * @param {String} item String name of row item
 * @param {Boolean} card Display rows with card styling (if available);
 * @return {JSX} Returns presentation JSX DataListView component
 */
const DataListView = ({ style, data, rows, scrollEnabled, item, card }) => (
	<FlatList
		style={[style, css.scroll_default]}
		contentContainerStyle={rows ? null : css.main_full}
		data={rows ? data.slice(0,rows) : data}
		scrollEnabled={scrollEnabled}
		keyExtractor={(listItem, index) => {
			// Specify the unique key that each kind of
			// item will use to identify itself. Each
			// item MUST have a unique key!
			switch (item) {
				case 'DiningItem': {
					if (listItem.id) return listItem.id + index
					else return listItem.name + index
				}
				case 'LinksItem': {
					return listItem.name + index
				}
				default: {
					return index
				}
			}
		}}
		renderItem={({ item: rowData }) => {
			// Add to switch statement as new Items are needed
			// Only reason this is a switch is cuz Actions from react-router-flux doesn't like being passed JSX
			// Should revisit to see if this can be simplified
			switch (item) {
				case 'DiningItem': {
					return (<DiningItem data={rowData} card={card} />)
				}
				case 'LinksItem': {
					return (<LinksItem data={rowData} card={card} />)
				}
				default: {
					return null
				}
			}
		}}
	/>
)

export default DataListView
